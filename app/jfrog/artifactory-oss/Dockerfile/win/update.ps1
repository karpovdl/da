#power shell

#jfrog artifactory oss

# Params

#$args[0] - app name
#$args[1] - version prev
#$args[2] - version next
#$args[3] - app port
#$args[4] - app port ui
#$args[5] - sub path for data folder
#$args[6] - docker id

$appName    = $args[0]
$appVerPrev = $args[1]
$appVerNext = $args[2]
$appPort    = $args[3]
$appPortUi  = $args[4]
$appDataDir = $args[5]
$uid        = $args[6]

echo $appName $appVerPrev $appVerNext $appPort $appDataDir $uid

# App path
New-Item -ItemType Directory -Force -Path c:/assets/app/${appDataDir}

# Docker pull and run
docker pull docker.bintray.io/jfrog/artifactory-oss:${appVerNext}
@(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}") | %{docker stop $(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}")}
@(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}") | %{docker rename ${appName}_${appVerPrev}_${appPort} ${appName}_${appVerPrev}_${appPort}.$(@(Get-Date -format 'yyyMMdd_HHmmss')).bak}
docker run --restart always -d `
 --name ${appName}_${appVerNext}_${appPort} `
 --hostname=dp-${appName}-${appVerNext}-${appPort} `
 --network=dp-net `
 -p ${appPort}:8081 `
 -p ${appPortUi}:8082 `
 -e TZ='Europe/Moscow' `
 -v /host_mnt/c/assets/app/${appDataDir}:/var/opt/jfrog/artifactory `
 docker.bintray.io/jfrog/artifactory-oss:${appVerNext}
@(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}" --filter status=exited) | %{docker rm -v -f $(docker ps -aqf "name=${appName}_${appVerPrev}_${appPort}" --filter status=exited)}
@(docker images -f dangling=true -q) | %{docker rmi $(docker images -f dangling=true -q)}

if (${uid}) {
  # Docker push
  docker login

  docker tag docker.bintray.io/jfrog/artifactory-oss:${appVerNext} ${uid}/jfrog-artifactory-oss:${appVerNext}
  docker push ${uid}/jfrog-artifactory-oss:${appVerNext}

  docker tag docker.bintray.io/jfrog/artifactory-oss:${appVerNext} ${uid}/jfrog-artifactory-oss
  docker push ${uid}/jfrog-artifactory-oss

  docker logout
}

echo Success