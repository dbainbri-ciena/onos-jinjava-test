/*
 * Copyright 2018-present Ciena Corporation
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
package com.ciena.onos;

import static org.slf4j.LoggerFactory.getLogger;

import org.apache.felix.scr.annotations.Component;
import org.slf4j.Logger;

/**
 * Loader for Ciena device drivers.
 */
@Component(immediate = true)
public class JinjavaComponent {

    private static final Logger log = getLogger(JinjavaComponent.class);

    public JinjavaComponent() {
    }

    protected void activate() {
        try {
            JinjavaComponent.class.getClassLoader().loadClass("com.hubstop.jinjava.Jinjava");
        } catch (Throwable t) {
            log.error("ERROR {}", t.toString(), t);
        }
    }

    protected void deactivate() {
    }
}
