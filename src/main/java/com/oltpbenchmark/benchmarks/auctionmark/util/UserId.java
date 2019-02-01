/******************************************************************************
 *  Copyright 2015 by OLTPBenchmark Project                                   *
 *                                                                            *
 *  Licensed under the Apache License, Version 2.0 (the "License");           *
 *  you may not use this file except in compliance with the License.          *
 *  You may obtain a copy of the License at                                   *
 *                                                                            *
 *    http://www.apache.org/licenses/LICENSE-2.0                              *
 *                                                                            *
 *  Unless required by applicable law or agreed to in writing, software       *
 *  distributed under the License is distributed on an "AS IS" BASIS,         *
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  *
 *  See the License for the specific language governing permissions and       *
 *  limitations under the License.                                            *
 ******************************************************************************/


package com.oltpbenchmark.benchmarks.auctionmark.util;

import com.oltpbenchmark.util.CompositeId;

public class UserId extends CompositeId {

    private static final int COMPOSITE_BITS[] = {
            16, // ITEM_COUNT
            24, // OFFSET
    };
    private static final long COMPOSITE_POWS[] = compositeBitsPreCompute(COMPOSITE_BITS);

    /**
     * The size index is the position in the histogram for the number
     * of users per items size
     */
    private int itemCount;

    /**
     * The offset is based on the number of users that exist at a given size index
     */
    private int offset;

    public UserId() {
        // For serialization
    }

    /**
     * Constructor
     *
     * @param itemCount
     * @param offset
     */
    public UserId(int itemCount, int offset) {
        this.itemCount = itemCount;
        this.offset = offset;
    }

    /**
     * Constructor
     * Converts a composite id generated by encode() into the full object
     *
     * @param composite_id
     */
    public UserId(long composite_id) {
        this.decode(composite_id);
    }

    @Override
    public long encode() {
        return (this.encode(COMPOSITE_BITS, COMPOSITE_POWS));
    }

    @Override
    public void decode(long composite_id) {
        long values[] = super.decode(composite_id, COMPOSITE_BITS, COMPOSITE_POWS);
        this.offset = (int) values[0];
        this.itemCount = (int) values[1];
    }

    @Override
    public long[] toArray() {
        return (new long[]{this.offset, this.itemCount});
    }

    public int getItemCount() {
        return this.itemCount;
    }

    public int getOffset() {
        return this.offset;
    }

    @Override
    public String toString() {
        return String.format("UserId<itemCount=%d,offset=%d>",
                this.itemCount, this.offset);
    }

    public static String toString(long userId) {
        return new UserId(userId).toString();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }

        if (!(obj instanceof UserId) || obj == null) {
            return false;
        }

        UserId o = (UserId) obj;
        return (this.itemCount == o.itemCount
                && this.offset == o.offset);
    }

    @Override
    public int hashCode() {
        int prime = 11;
        int result = 1;
        result = prime * result + itemCount;
        result = prime * result + offset;
        return result;
    }
}
