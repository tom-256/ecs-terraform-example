# ecs-terraform-example

1. create resouces
- task-def
- service
- cluster

2. describe task-def
```
$aws ecs describe-task-definition --task-definition <TASK_DEF_NAME>:<REVISION> >> task-def.json
```
fix task-def.json  
- remove taskDefinition layer
- fix image url to blank string
- fix executionRoleArn to role name "ecsTaskExecutionRole"

3. commit task-def

