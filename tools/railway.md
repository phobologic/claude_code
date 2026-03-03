# Railway CLI Reference

## Link & Status

```bash
railway link            # Link current directory to a Railway project
railway status          # Show current project, environment, and service
railway open            # Open the Railway dashboard for this project
railway whoami          # Show the logged-in Railway account
```

## Deployments

```bash
railway up              # Deploy current directory (interactive, streams logs)
railway up --detach     # Deploy without streaming logs (use in agent/non-interactive contexts)
railway redeploy        # Redeploy the latest build without new code push
railway restart         # Restart the running service without redeploying
```

## Environment Variables

```bash
railway variable list              # List all environment variables for the active environment
railway variable set KEY=VALUE     # Set an environment variable
railway variable delete KEY        # Remove an environment variable
```

## Logs & Debugging

```bash
railway logs                  # Stream live logs
railway logs -n 100           # Show last 100 log lines
railway logs --build          # Show build logs for the latest deploy
railway ssh                   # SSH into the running container
railway shell                 # Start an interactive shell in the service environment
railway run <cmd>             # Run a command with Railway env vars injected (e.g., migrations)
```

## Safety Conventions

- **Always run `railway status` before deploying** to confirm you're targeting the correct
  service and environment. Deploying to production when you meant staging is a bad day.

- **Use `--detach` in non-interactive or agent contexts.** Without it, `railway up` blocks
  while streaming logs and may never return cleanly in automated runs.

- **Use `railway run <cmd>` for one-off commands** (migrations, seed scripts, admin tasks)
  against production environment variables. Never copy secrets locally just to run a script.

- **Never set sensitive secrets via `railway variable set` in a shell session** where
  command history could be captured. Prefer the Railway dashboard for secrets like API keys,
  database credentials, and private tokens.
