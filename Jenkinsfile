#!groovy
node("continuous") {
    stage('build') {
        git url: 'git@github.com:strikead/carbonapi', branch: 'strikead', credentialsId: 'strikead-marvin'
        def cdocker = docker.build "carbonapi-${env.BUILD_NUMBER}"

        cdocker.inside {
            git url: 'git@github.com:strikead/carbonapi', branch: 'strikead', credentialsId: 'strikead-marvin'
            def go_path = '/home/go'
            def project_root_path = "${go_path}/src/github.com/go-graphite"
            def project_name = 'carbonapi'
            def project_path = "$project_root_path/$project_name"

            stage('Env preparation') {
                sh "mkdir -p ${project_root_path}"
                sh "cp -r ${env.WORKSPACE} ${project_path}"
            }

            stage('Build package') {
                env.GOPATH = go_path
                env.PATH = "${go_path}/bin:${env.PATH}"
                sh """
                    cd ${project_path}
                    make dep
                    contrib/fpm/create_package_deb.sh
                """
            }

            stage('artefacts deployment') {
                archiveArtifacts allowEmptyArchive: true, artifacts: '*.deb', onlyIfSuccessful: true
                def server = Artifactory.server "strikead-artifactory"
                def uploadSpec ="""{
                    "files": [
                        {
                            "pattern": "*.deb",
                            "target": "strikead-ubuntu/pool/thirdparty/xenial/",
                            "props": "deb.distribution=xenial-stable;deb.component=thirdparty;deb.architecture=all"
                        }
                    ]
                }"""
                def build_info = server.upload spec: uploadSpec
                server.publishBuildInfo(build_info)
            }
        }
    }
    stage('Cleanup') {
        deleteDir()
    }
}
