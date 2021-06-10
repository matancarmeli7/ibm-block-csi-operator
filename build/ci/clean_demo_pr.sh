#!/bin/bash -xe
set +o pipefail

export passed_k8s_checks=true
export passed_openshift_checks=true

wait_for_checks_to_complete(){
  community_operators_branch=$1
  all_checks_passed=true
  export repo_pr=`gh pr list --repo $github_csiblock_community_operators_repository | grep $community_operators_branch`
  if [[ "$repo_pr" == *"$community_operators_branch"* ]]; then
    sleep 5
    while [ "$(gh pr checks $community_operators_branch --repo $github_csiblock_community_operators_repository | grep -i pending | wc -l)" -gt 0 ]; do
      sleep 5
    done
    if [ "$(gh pr checks $community_operators_branch --repo $github_csiblock_community_operators_repository | grep -i fail | wc -l)" -gt 0 ]
    then
      export all_checks_passed=false
    fi
    echo "$all_checks_passed"
  fi
}

print_checks_and_delete_pr(){
  community_operators_branch=$1
  cluster_kind=$2  
  echo "The $cluster_kind checks:"
  gh pr checks $community_operators_branch --repo $github_csiblock_community_operators_repository
  gh pr close $community_operators_branch --delete-branch --repo $github_csiblock_community_operators_repository
}

passed_k8s_checks=$(wait_for_checks_to_complete $community_operators_kubernetes_branch)
print_checks_and_delete_pr $community_operators_kubernetes_branch 'kubernetes'
passed_openshift_checks=$(wait_for_checks_to_complete $community_operators_openshift_branch)
print_checks_and_delete_pr $community_operators_openshift_branch 'openshift'

if [ $passed_k8s_checks == "false" ] || [ $passed_openshift_checks == "false" ]
then
  echo "some test failed :("
  exit 1
fi