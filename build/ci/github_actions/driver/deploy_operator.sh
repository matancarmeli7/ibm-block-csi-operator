#!/bin/bash -xel
set +o pipefail

edit_operator_yaml_image (){
  cd $(dirname $operator_yaml)
  operator_image_in_branch=`yq eval '(. | select(.kind == "Deployment") | .spec.template.spec.containers[0].image)' $(basename $operator_yaml)`
  sed -i "s+$operator_image_in_branch+$operator_image_for_test+g" $(basename $operator_yaml) ## TODO: CSI-3223 avoid using sed
cd -
}

edit_operator_yaml_image
cat $operator_yaml | grep image:
kubectl apply -f $operator_yaml
. wait_for_pods_ready_utils.sh && wait_for_pod_to_start "operator"
. wait_for_pods_ready_utils.sh && assert_expected_image_in_pod "operator" $operator_image_for_test
. wait_for_pods_ready_utils.sh && wait_for_driver_deployment_to_finish