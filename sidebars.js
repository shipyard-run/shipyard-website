/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

module.exports = {
  docs: {
    "Shipyard Introduction": ['install', 'running', 'wsl2'],
    "Shipyard CLI": [
      'commands/env',
      'commands/purge',
      'commands/push'
    ],
    Resources: [
      'resources/container',
      'resources/sidecar',
      'resources/k8s_cluster',
      'resources/k8s_config',
      'resources/k8s_ingress',
      'resources/helm',
      'resources/nomad_cluster',
      'resources/nomad_job',
      'resources/nomad_ingress',
      'resources/exec_remote',
      'resources/module'
    ]
  },
};
