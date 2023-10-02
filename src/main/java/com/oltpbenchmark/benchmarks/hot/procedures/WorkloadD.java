/*
 * Copyright 2020 by OLTPBenchmark Project
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
 *
 */

package com.oltpbenchmark.benchmarks.hot.procedures;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Random;

public class WorkloadD extends BasicProcedures {
    public void run(Connection conn, Key[] keys, String[] vals, String[] results, Random rng)
            throws SQLException {
        for (Key k : keys) {
            if (rng.nextInt(100) < 95) {
                read(conn, k, results);
                System.out.printf("%s(R) ", k.name);
            } else {
                insert(conn, k, vals);
                System.out.printf("%s(I) ", k.name);
            }
        }
        System.out.println();
    }
}
