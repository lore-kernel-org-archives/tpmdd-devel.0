From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Wed, 1 Feb 2017 17:11:16 -0500
Message-ID: <o6tmdu$3dc$1@blaine.gmane.org>
References: <1485563481.3229.39.camel@HansenPartnership.com>
	<1485563558.3229.41.camel@HansenPartnership.com>
	<20170131162115.vptki5ykmpnx27ym@intel.com>
	<1485903340.3199.107.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1485903340.3199.107.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/31/2017 5:55 PM, James Bottomley wrote:
>
> I can do that, but I think this should be higher than debug.  If this
> trips, something an application was doing will fail with a non TPM
> error and someone may wish to investigate why.  Having a kernel message
> would help with that (but they won't see it if it's debug).
>
> I'm also leaning towards the idea that we should actually have one more
> _tbl slot than we know the TPM does, so that if someone goes over it's
> the TPM that gives them a real TPM out of memory error rather than the
> space code returning -ENOMEM.

I endorse this as a general principle.

1 - When a TPM application does something wrong, the developer will be 
looking for a specific TPM error, not a kernel read() error.

Reserve the kernel errors for when something goes wrong in the device 
driver, not in the application.

2 - As much as possible, the RM should be transparent to the 
application.  The RM should report a failure the same way the SW TPM 
would fail.




------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
