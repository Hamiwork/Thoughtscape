import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";
// The small local API runs in Vite's server process; secrets never enter VITE_*.
// @ts-expect-error Plain server JavaScript is tested by Node, not shipped to clients.
import { createAIMiddleware, serviceConfig } from "./server/api.mjs";
export default defineConfig(({ mode }) => {
  const middleware = () =>
    createAIMiddleware(() =>
      serviceConfig({
        ...loadEnv(mode, process.cwd(), "THOUGHTSCAPE_"),
        ...process.env,
      }),
    );
  return {
    base: process.env.THOUGHTSCAPE_BASE_PATH || "/",
    plugins: [
      react(),
      {
        name: "thoughtscape-local-ai",
        configureServer(server) {
          server.middlewares.use("/api", middleware());
        },
        configurePreviewServer(server) {
          server.middlewares.use("/api", middleware());
        },
      },
    ],
  };
});
