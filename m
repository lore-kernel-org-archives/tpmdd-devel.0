From: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: TPM2 resource manager context save
Date: Fri, 9 Jun 2017 10:29:24 -0400
Message-ID: <9679ee72-15db-0f20-2610-60672868bba1@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

At least a question, maybe a bug ...

What is the expected behavior for the resource manager when it receives 
contextsave for a transient object?
]
~~

Use case:

Creating an RSA primary key can take a long time.  I've seen it take 90 
seconds.  The SRK will probably be made persistent.  However, there are 
a limited number of persistent object slots.  So the less frequently 
used EK will likely be created on demand.

To improve performance, an application can context save the EK, and then 
context load it when needed.  This is a symmetric key operation, and is 
much faster.  This can work even for a new connection.

~~

When I try the command, write() returns 22, EINVAL

The RM seems to have some special handling for context save in 
tpm2_cmd.c:tpm2_get_cc_attrs_tbl().  Later, the write() returns EINVAL 
(22), probably because tpm2_map_command() does not find 
TPM2_CC_CONTEXT_SAVE in the attribute table.

~~

Question:  Is this expected?  Is it the desired design?

Bug:  IMHO, EINVAL is a poor choice, as the application thinks the 
write() failed.  In fact, the TPM write() didn't even occur.  Better 
would be to construct the standard TPM response to an unimplemented 
command:  TPM_RC_COMMAND_CODE.  This tells the application more 
accurately what failed - the command code is not permitted.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
