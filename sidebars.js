/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

module.exports = {
  docs: {
    'Shipyard Introduction': [
      'install', 
      'running', 
      'wsl2'
    ],
    'Shipyard CLI': [
      'commands/destroy',
      'commands/env',
      'commands/log',
      'commands/output',
      'commands/purge',
      'commands/push',
      'commands/run',
      'commands/test',
      'commands/version'
    ],
    Resources: [
      'resources/blueprint',
      'resources/container',
      'resources/documentation',
      'resources/exec_remote',
      'resources/exec_local',
      'resources/helm',
      'resources/ingress',
      'resources/k8s_cluster',
      'resources/k8s_config',
      'resources/k8s_ingress',
      'resources/module',
      'resources/network',
      'resources/nomad_cluster',
      'resources/nomad_job',
      'resources/nomad_ingress',
      'resources/output',
      'resources/sidecar',
      'resources/template',
      'resources/variable',
      'resources/meta',
      'resources/functions'
    ],
    Tutorials: [
      'tutorials/creating',
      'tutorials/testing'
    ]
  }
}
