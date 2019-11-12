/**
 * Copyright 2019 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package decoder

import (
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	yamlutil "k8s.io/apimachinery/pkg/util/yaml"
)

func FromJsonToUnstructured(json []byte) (*unstructured.Unstructured, error) {
	obj := &unstructured.Unstructured{}
	err := obj.UnmarshalJSON(json)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func FromYamlToUnstructured(yaml []byte) (*unstructured.Unstructured, error) {
	json, err := yamlutil.ToJSON(yaml)
	if err != nil {
		return nil, err
	}
	return FromJsonToUnstructured(json)
}

func FromJsonToUnstructuredList(json []byte) (*unstructured.UnstructuredList, error) {
	obj := &unstructured.UnstructuredList{}
	err := obj.UnmarshalJSON(json)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func FromYamlToUnstructuredList(yaml []byte) (*unstructured.UnstructuredList, error) {
	json, err := yamlutil.ToJSON(yaml)
	if err != nil {
		return nil, err
	}
	return FromJsonToUnstructuredList(json)
}
