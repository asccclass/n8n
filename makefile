image=docker.n8n.io/n8nio/n8n
containerName=n8n
DBServer=Qdrant
port=5678
CURDIR=D:\n8n\\

s:
	git push -u origin main

clean:
	docker system prune -a -f
	docker volume prune

stop:
	docker stop ${containerName}
	docker stop Redisx

rm:
	docker rm -f ${containerName}

runDB:
	docker run --rm -d -p 6333:6333 --name ${DBServer} -p 6334:6334 \
	-v ${CURDIR}qdrant_storage:/qdrant/storage:z \
	qdrant/qdrant

stopDB:
	docker stop ${DBServer}
	docker rm -f ${DBServer}

redis:
	docker run -it --rm -d --name Redisx \
	-v redisdata:/data -p 6379:6379 \
	redis:latest

run: redis
	docker run -d --rm --name ${containerName} \
	-p ${port}:5678 \
	-v ${CURDIR}data:/home/node/.n8n \
	--env-file D:\n8n\envfile \
	--link Redisx:Redisx \
	${image}

re: stop rm run