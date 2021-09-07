#### Last Updated v2.0.0 (08/25/2021)

# Additional Usage Examples (WIP)
Rake commands should be ran from the root of terraform directory.

## Basics
#### Display Current Orchestrator Environment
```bash
rake env
```

#### Display Built Stack Info
```bash
rake info
```

#### List All Rake Tasks
[Rake Task List](../reference/rake_task_list.md)

```bash
rake -T
```

#### Search for a Rake Task by Name
```bash
rake -T <part of task name>
```

##### Examples
```bash
rake -T terraform
```

```bash
rake -T packer
```
