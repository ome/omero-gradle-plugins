pipeline {
    agent {
        label 'testintegration'
    }

    environment {
        // Default credentials for testing on devspace
        MAVEN_SNAPSHOTS_REPO_URL = 'http://nexus:8081/nexus/repository/maven-internal/'
        MAVEN_USER = 'admin'
        MAVEN_PASSWORD = 'admin123'

        // omero-artifact-plugin handles publishing of other artifacts, but it also needs to publish itself
        MAVEN_REPO_URL  = 'http://nexus:8081/nexus/repository/maven-internal/'

        // Disable Gradle daemon
        GRADLE_OPTS = '-Dorg.gradle.daemon=false'
    }

    stages {
        stage('Versions') {
            steps {

                copyArtifacts(projectName: 'BIOFORMATS-push', flatten: true, filter: 'target/version.properties')

                // build is in .gitignore so we can use it as a temp dir
                sh """
                    mkdir ${env.WORKSPACE}/build
                    cd ${env.WORKSPACE}/build && curl -sfL https://github.com/ome/build-infra/archive/master.tar.gz | tar -zxf -
                    export PATH=$PATH:${env.WORKSPACE}/build/build-infra-master/
                    cd ..
                    # Workaround for "unflattened" file, possibly due to matrix
                    find . -name version.properties -exec cp {} . \\;
                    test -e version.properties
                    foreach-get-version-as-property >> version.properties
                """
                 archiveArtifacts artifacts: 'version.properties'
                }
        }
        stage('Build') {
            steps {
                sh '''
                   git submodule update --init --recursive
                   gradle --init-script init-ci.gradle publishToMavenLocal
                   '''
            }
        }
        stage('Deploy') {
            steps {
                sh 'gradle --init-script init-ci.gradle publish'
            }
        }
    }

    post {
        always {
            // Cleanup workspace
            deleteDir()
        }
    }
}
