import React from "react";

const config = {
    ROMS: {
        fg_nes: {
            name: "FanGraphs Arcade",
            description: (
                <span>
                    <a
                        href="https://www.fangraphs.com"
                        target="_blank"
                        rel="noopener noreferrer"
                    >
            FanGraphs Arcade
                    </a>{" "}
          by Sean Dolinar
                </span>
            ),
            url: `${process.env.PUBLIC_URL}/roms/nes_fg/nes_fg.nes`
        }
    },
    GOOGLE_ANALYTICS_CODE: process.env.REACT_APP_GOOGLE_ANALYTICS_CODE,
    SENTRY_URI: process.env.REACT_APP_SENTRY_URI
};

export default config;

