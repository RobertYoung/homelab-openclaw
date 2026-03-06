# homelab-openclaw

Ansible playbook for deploying OpenClaw on `openclaw.local.iamrobertyoung.co.uk`.

OpenClaw runs as a host systemd service behind Traefik (Docker) as a reverse proxy with TLS termination via Step CA. UFW blocks direct external access to the gateway port, routing all traffic through Traefik on port 443.

## Architecture

```
Internet → UFW (443 allowed, 18789 blocked) → Traefik (Docker, TLS via Step CA)
         → host.docker.internal:18789 → OpenClaw gateway (host systemd service)
                                       → Docker agent sandboxes
```

## Quick Start

```bash
# Install dependencies
aws-vault exec iamrobertyoung:home-assistant-production:p -- ansible-galaxy install -r requirements.yml -p .roles

# Test connectivity
aws-vault exec iamrobertyoung:home-assistant-production:p -- ansible openclaw -m ping

# Deploy
aws-vault exec iamrobertyoung:home-assistant-production:p -- ansible-playbook playbooks/site.yml
```

## Initial Onboarding

After the first deploy, run the OpenClaw onboarding wizard on the target host to configure credentials, channels, and install the gateway service:

```bash
su -s /bin/bash -l openclaw
openclaw onboard
```

This runs as the `openclaw` user so all created files are correctly owned and `HOME` points to `/var/lib/openclaw`. The onboarding wizard will install the gateway as a systemd user service.

See [CLAUDE.md](CLAUDE.md) for full documentation.
