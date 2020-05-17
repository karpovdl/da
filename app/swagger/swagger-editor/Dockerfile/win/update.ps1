#power shell

#swagger ui

# Params
#$args[0] - app name
#$args[1] - version prev
#$args[2] - version next
#$args[3] - app port
#$args[4] - sub path for data folder

$appName    = $args[0]
$appVerPrev = $args[1]
$appVerNext = $args[2]
$appPort    = $args[3]
$appDataDir = $args[4]

echo $appName $appVerPrev $appVerNext $appPort $appDataDir

# Config
New-Item -ItemType Directory -Force -Path c:/assets/app/${appDataDir}
cp ../../../conf/swagger.json c:/assets/app/${appDataDir}

docker pull swaggerapi/swagger-editor:${appVerNext}
@(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}") | %{docker stop $(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}")}
@(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}") | %{docker rename ${appName}_${appVerPrev}_${appPort} ${appName}_${appVerPrev}_${appPort}.$(@(Get-Date -format 'yyyMMdd_HHmmss')).bak}
docker run --restart always -d `
 --name ${appName}_${appVerNext}_${appPort} `
 --hostname=dp-${appName}-${appVerNext}-${appPort} `
 --network=dp-net `
 -p ${appPort}:8080 `
 -e SWAGGER_JSON='/app/swagger.json' `
 -e TZ='Europe/Moscow' `
 -v /host_mnt/c/assets/app/${appDataDir}:/app `
 swaggerapi/swagger-editor:${appVerNext}
@(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}" --filter status=exited) | %{docker rm -v -f $(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}" --filter status=exited)}
@(docker images -f dangling=true -q) | %{docker rmi $(docker images -f dangling=true -q)}

echo Success