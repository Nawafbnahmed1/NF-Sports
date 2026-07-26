import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async () => {
  try {
    const apiKey = Deno.env.get("THE_SPORTS_DB_KEY");

    if (!apiKey) {
      return new Response(
        JSON.stringify(
          {
            success: false,
            error: "THE_SPORTS_DB_KEY is missing",
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

    const url =
      `https://www.thesportsdb.com/api/v1/json/${apiKey}/all_leagues.php`;

    const response = await fetch(url);

    if (!response.ok) {
      return new Response(
        JSON.stringify(
          {
            success: false,
            status: response.status,
            statusText: response.statusText,
          },
          null,
          2,
        ),
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
      JSON.stringify(
        {
          success: true,
          source: "TheSportsDB",
          leaguesCount: json.leagues?.length ?? 0,
          firstLeague: json.leagues?.[0] ?? null,
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
          error: String(err),
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
