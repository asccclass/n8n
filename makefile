image=docker.n8n.io/n8nio/n8n
containerName=n8n
DBServer=Qdrant
port=5678
CURDIR=D:\n8n\\

stop:
	docker stop ${containerName}

rm:
	docker rm -f ${containerName}

run: runDB
	docker run -d --rm --name ${containerName} \
	-p ${port}:5678 \
	-v ${CURDIR}data:/home/node/.n8n \
	--env-file D:\n8n\envfile \
	--link ${DBServer}:${DBServer} \
	${image}

stopDB:
	docker stop ${DBServer}
	docker rm -f ${DBServer}

runDB:
	docker run -d -p 6333:6333 --name ${DBServer} -p 6334:6334 \
	-v ${CURDIR}qdrant_storage:/qdrant/storage:z \
	qdrant/qdrant

re: stop rm run