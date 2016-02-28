ecs-list:
	aws ecr describe-repositories

ecr-images:
	aws ecr list-images --repository-name derrickpetzold
