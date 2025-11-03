# User Management & Access Control

## What This Does
Demonstrates how to configure users, roles, and permissions in Cybus Connectware for secure Industrial IoT deployments.

## Quick Setup
1. **Configure users**: Review user roles in `users-example-commissioning-file.yml`
2. **Deploy service**: `docker exec -it connectware-container cybus-ctl commissioning-file apply users-example-commissioning-file.yml`
3. **Test access**: Verify users can access assigned MQTT topics with proper permissions

## Key Configuration Areas
| Component | Description | Example |
|-----------|-------------|---------|
| Users | Individual user accounts | operators, engineers, admins |
| Roles | Permission groups | read-only, operator, admin |
| MQTT ACL | Topic-level access control | `factory/+/read`, `alarms/+/write` |

## What's Next
- Secure connections: [TLS Certificates](../mqtt-tls-certificates/)
- Monitor user activity: [Audit Logging](../../monitoring/elasticsearch/)
- Advanced authentication: [LDAP Integration](https://docs.cybus.io/)

## Full Tutorial
For detailed guidance, see: [User Management Basics](https://learn.cybus.io/user-management-basics/)