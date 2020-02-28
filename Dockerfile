FROM docker.artifactory-eu.soleng-emea-staging.jfrog.team/conanio/gcc7:latest

ARG cfg_repo
ARG artifactory 
ARG ci_user
ARG apikey 
ARG art_repo 
ARG up_pattern 
ARG build_name 
ARG build_number
ARG component

ENV CONAN_REVISIONS_ENABLED=1 
ENV CONAN_USER_HOME=/tmp/conan/
#ENV CONAN_LOGGING_LEVEL=10

WORKDIR /tmp

COPY scripts scripts/  
COPY config config/  

#install remotes, profiles, global conf
RUN ./scripts/config_project.sh -c $cfg_repo -a $artifactory -u $ci_user -k $apikey -r $art_repo -i $build_name -n $build_number 

RUN git clone https://github.com/conan-ci-cd-training/${component}.git 

RUN scripts/create_pkg.sh -p "conanio-gcc7" -f $component 

RUN scripts/upload.sh -a $artifactory -k $apikey -r $art_repo -p "conanio-gcc7" -u "$up_pattern" -f $component 

RUN scripts/generate_bi.sh -u $ci_user -k $apikey -o "gcc7-${build_name}.json" -l $component

RUN scripts/merge_and_publish.sh -a $artifactory -u $ci_user -k $apikey -i gcc7-${build_name} 
