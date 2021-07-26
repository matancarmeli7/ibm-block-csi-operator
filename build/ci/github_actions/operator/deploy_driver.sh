#!/bin/bash -xel
set +o pipefail

if [ "$driver_images_tag" == "develop" ]; then
  driver_images_tag=latest
fi
operator_image_for_test=$operator_image_repository_for_test:$operator_image_tag_for_test

kind_node_name=`docker ps --format "{{.Names}}"`
docker exec -i $kind_node_name apt-get update
docker exec -i $kind_node_name apt -y install open-iscsi

edit_cr_images (){
  cd $(dirname $cr_file)
  chmod 547 $(basename $cr_file)
  declare -A cr_image_fields=(
      [".spec.controller.repository"]="$controller_repository_for_test"
      [".spec.controller.tag"]="$driver_images_tag"
      [".spec.node.repository"]="$node_repository_for_test"
      [".spec.node.tag"]="$driver_images_tag"
  )
  for image_field in ${!cr_image_fields[@]}; do
      cr_image_value=${cr_image_fields[${image_field}]}
      yq eval "${image_field} |= env(cr_image_value)" $(basename $cr_file) -i
  done
  cd -
}

edit_cr_images

edit_operator_yaml_image (){
  cd $(dirname $operator_yaml)
  operator_image_in_branch=`yq eval '(.spec.template.spec.containers[0].image | select(. == "*ibmcom*"))' $(basename $operator_yaml)`
  sed -i "s+$operator_image_in_branch+$operator_image_for_test+g" $(basename $operator_yaml)
cd -
}

edit_operator_yaml_image

cat $operator_yaml | grep image:
cat $cr_file | grep repository:
cat $cr_file | grep tag:

kubectl apply -f $operator_yaml
kubectl apply -f $cr_file