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


# run task
```
$aws ecs register-task-definition --cli-input-json file://<ABSOLUTE_PATH_TO_TASK_DEF>
$aws ecs run-task --cluster <CLUSTER_NAME> --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[<SUBNETS_A>,<SUBNETS_C>],securityGroups=[<SG>]}" <TASK_DEF_NAME>
```