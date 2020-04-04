/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import React from 'react';
import classnames from 'classnames';
import Layout from '@theme/Layout';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './styles.module.css';

function Home() {
  const context = useDocusaurusContext();
  const {siteConfig = {}} = context;
  return (
    <Layout
      title={`Hello from ${siteConfig.title}`}
      description="Description will go into a meta tag in <head />">
      <header className={classnames('hero hero--primary', styles.heroBanner)}>
        <div className="container">
          <h1 className="hero__title"><img src="/img/shipyard_horizontal.png"/></h1>
          <p className="hero__subtitle">{siteConfig.tagline}</p>
          <div>
            <img src='/img/install.svg'/>
          </div>
          <div style={{margin: '40px'}}></div>
          <div>
            <Link
              className={classnames(
                'button button--secondary button--lg',
                styles.getStarted,
              )}
              to={useBaseUrl('docs/install')}>
              Install Shipyard
            </Link>
          </div>
        </div>
      </header>
      <main className={styles.features}>
        <div className="container">
          <div className="row">
            <div className="col">
              <h1>Try the Shipyard Vault and Kubernetes environment</h1>
              <pre>
                curl https://shipyard.run/apply | bash -s github.com/shipyard-run/blueprints//vault-k8s
              </pre>
              <p className={styles.section}>
                <h2>Or view the <a href="/docs/install">documentation</a> for other installation options.</h2>
              </p>
            </div>
          </div>
        </div>
      </main>
    </Layout>
  );
}

export default Home;
