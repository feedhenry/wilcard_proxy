#!groovy

// https://github.com/feedhenry/fh-pipeline-library
@Library('fh-pipeline-library') _

fhBuildNode(['label': 'openshift']) {

    final String COMPONENT = 'wildcard_proxy'
    final String VERSION = '1.0.0'
    final String BUILD = env.BUILD_NUMBER
    final String DOCKER_HUB_ORG = 'feedhenry'
    final String DOCKER_HUB_REPO = 'wildcard-proxy-centos'
    final String CHANGE_URL = env.CHANGE_URL

    stage('Platform Update') {
        final Map updateParams = [
                componentName: 'fh-wildcard-proxy',
                componentVersion: VERSION,
                componentBuild: BUILD,
                changeUrl: CHANGE_URL
        ]
        fhCoreOpenshiftTemplatesComponentUpdate(updateParams)
    }

    stage('Build Image') {
        final Map params = [
                fromDir: './docker',
                buildConfigName: 'wildcard-proxy',
                imageRepoSecret: "dockerhub",
                outputImage: "docker.io/${DOCKER_HUB_ORG}/${DOCKER_HUB_REPO}:${VERSION}-${BUILD}"
        ]
        buildWithDockerStrategy params
        archiveArtifacts writeBuildInfo(COMPONENT, "${VERSION}-${BUILD}")
    }

}
