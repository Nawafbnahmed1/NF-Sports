import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type FootballDataCompetition = {
  id: number;
  name: string;
};

type FootballDataTeam = {
  id: number;
  name: string;
  shortName?: string | null;
  tla?: string | null;
  crest?: string | null;
};

type FootballDataMatch = {
  id: number;
  utcDate: string;
  status: string;
  competition: FootballDataCompetition;
  homeTeam: FootballDataTeam;
  awayTeam: FootballDataTeam;
  score?: {
    fullTime?: {
      home?: number | null;
      away?: number | null;
    };
  };
};

serve(async () => {
  try {
    const apiKey = Deno.env.get("FOOTBALL_DATA_API_KEY");
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!apiKey || !supabaseUrl || !serviceKey) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Missing environment variables",
        }),
        {
          status: 500,
          headers: {
            "Content-Type": "application/json",
          },
        },
      );
    }

    const supabase = createClient(supabaseUrl, serviceKey);

    const response = await fetch(
      "https://api.football-data.org/v4/matches?dateFrom=2026-07-24&dateTo=2026-07-24",
      {
        headers: {
          "X-Auth-Token": apiKey,
          Accept: "application/json",
        },
      },
    );

    if (!response.ok) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Football-Data API request failed",
          status: response.status,
          statusText: response.statusText,
        }),
        {
          status: response.status,
          headers: {
            "Content-Type": "application/json",
          },
        },
      );
    }

    const json = await response.json();

    return new Response(
      JSON.stringify(json, null, 2),
      {
        headers: {
          "Content-Type": "application/json",
        },
      },
    );

    const matches: FootballDataMatch[] = Array.isArray(json.matches)
      ? json.matches
      : [];

    const leagueCache = new Map<number, string>();
    const teamCache = new Map<number, string>();

    let leaguesSynced = 0;
    let teamsSynced = 0;
    let matchesSynced = 0;
    const errors: Array<{ matchId?: number; error: string }> = [];

    const upsertLeague = async (competition: FootballDataCompetition) => {
      if (leagueCache.has(competition.id)) {
        return leagueCache.get(competition.id)!;
      }

      const { data, error } = await supabase
        .from("leagues")
        .upsert(
          {
            football_data_id: competition.id,
            name: competition.name,
          },
          {
            onConflict: "football_data_id",
          },
        )
        .select("id")
        .single();

      if (error || !data) {
        throw new Error(error?.message ?? "Failed to upsert league");
      }

      leagueCache.set(competition.id, data.id);
      leaguesSynced++;
      return data.id as string;
    };

    const upsertTeam = async (team: FootballDataTeam) => {
      if (teamCache.has(team.id)) {
        return teamCache.get(team.id)!;
      }

      const { data, error } = await supabase
        .from("teams")
        .upsert(
          {
            football_data_id: team.id,
            name: team.name,
            short_name: team.shortName ?? null,
            tla: team.tla ?? null,
            crest: team.crest ?? null,
          },
          {
            onConflict: "football_data_id",
          },
        )
        .select("id")
        .single();

      if (error || !data) {
        throw new Error(error?.message ?? "Failed to upsert team");
      }

      teamCache.set(team.id, data.id);
      teamsSynced++;
      return data.id as string;
    };

    for (const match of matches) {
      try {
        const leagueId = await upsertLeague(match.competition);
        const homeTeamId = await upsertTeam(match.homeTeam);
        const awayTeamId = await upsertTeam(match.awayTeam);

        const { error: matchError } = await supabase
          .from("matches")
          .upsert(
            {
              football_data_id: match.id,
              league_id: leagueId,
              home_team_id: homeTeamId,
              away_team_id: awayTeamId,
              home_team_name: match.homeTeam.name,
              away_team_name: match.awayTeam.name,
              match_date: match.utcDate,
              home_score: match.score?.fullTime?.home ?? null,
              away_score: match.score?.fullTime?.away ?? null,
              status: match.status,
              updated_at: new Date().toISOString(),
            },
            {
              onConflict: "football_data_id",
            },
          );

        if (matchError) {
          throw new Error(matchError.message);
        }

        matchesSynced++;
      } catch (err) {
        errors.push({
          matchId: match.id,
          error: err instanceof Error ? err.message : String(err),
        });
      }
    }

    return new Response(
      JSON.stringify(
        {
          success: true,
          report: {
            leagues_synced: leaguesSynced,
            teams_synced: teamsSynced,
            matches_synced: matchesSynced,
            errors_count: errors.length,
            errors,
          },
        },
        null,
        2,
      ),
      {
        headers: {
          "Content-Type": "application/json",
        },
      },
    );
  } catch (err) {
    return new Response(
      JSON.stringify(
        {
          success: false,
          error: err instanceof Error ? err.message : String(err),
        },
        null,
        2,
      ),
      {
        status: 500,
        headers: {
          "Content-Type": "application/json",
        },
      },
    );
  }
});