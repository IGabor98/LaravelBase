docker-up:
	docker-compose up -d
docker-build:
	docker-compose up --build -d
docker-down:
	docker-compose down
composer-install:
	docker-compose exec -T app composer install
migrate:
	docker-compose exec -T app php artisan migrate
seed:
	docker-compose exec -T app php artisan db:seed
swagger-generate:
	docker-compose exec -T app php artisan l5-swagger:generate
seed-module:
	docker-compose exec -T app php artisan module:seed
clear-cache:
	docker-compose exec -T app php artisan cache:clear
