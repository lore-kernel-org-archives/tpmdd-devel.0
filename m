From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/7] tpm: infrastructure for TPM spaces
Date: Wed, 22 Mar 2017 16:09:21 -0400
Message-ID: <f8d414fa-03f9-2c22-8ddf-497c1d281536@us.ibm.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
	<20170216192529.25467-5-jarkko.sakkinen@linux.intel.com>
	<58AC85F2.5000406@linux.vnet.ibm.com>
	<1487785159.2376.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1487785159.2376.27.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 2/22/2017 12:39 PM, James Bottomley wrote:
>
> Right at the moment the kernel use of tpm2 looks like
>
> acquire chip->tpm_mutex
> load key
> process key
> unload key
> release chip->tpm_mutex
>
> While it does this, there's no need for it to have a RM interface
> because what it does between the acquisition and drop of the mutex
> can't be seen by or have any effect on userspace (whether it uses the
> RM or not).  So currently, the question doesn't arise, which is the
> situation you see.

1 - This appears to depend on the RM not releasing the mutex until all 
objects are swapped out.  Correct?  Same for sessions?

2 - A startauthsession can cause a regap error.  Does the above depend 
on the RM doing early regapping so the RM won't see that error?

3 - There's also the problem where the TPM saved session slots 
(typically 64) are full.  My intuition is that the best solution is for 
the RM to reserve 3 slots for the kernel.



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
