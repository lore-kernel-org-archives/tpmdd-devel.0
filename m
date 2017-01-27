From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v3 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Fri, 27 Jan 2017 17:01:52 -0500
Message-ID: <o6gg06$4j6$1@blaine.gmane.org>
References: <20170120133914.2wk43nteh2hh7n3c@intel.com>
	<20170120210522.glx4y4oui36oimld@intel.com>
	<1485107342.2504.7.camel@HansenPartnership.com>
	<1485110892.2504.12.camel@HansenPartnership.com>
	<20170122203055.zg52yraahqvn4rbv@intel.com>
	<20170122210107.zwrvuhnelrvaoe5h@intel.com>
	<20170122210441.ivzujugb3urzndhj@intel.com>
	<1485120988.2504.21.camel@HansenPartnership.com>
	<20170123140942.svnurymdxsyo6cum@intel.com>
	<20170123165823.hbgwphsqqpn6jwiz@intel.com>
	<20170123214255.vt2dumjm6jo5oxd3@intel.com>
	<1485209797.2534.29.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1485209797.2534.29.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
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

On 1/23/2017 5:16 PM, James Bottomley wrote:
>
> because the 0x9XX return codes don't have any parameter information
> that needs stripping and (rc & TPM2_RC_REFERENCE_H0) ==
> TPM2_RC_REFERENCE_H0)  will match any error code that has bits 11, 8
> and 5 set.
>
> I think the handle check was wrong too, it should have been
>
> if (rc & 0xff) == TPM2_RC_HANDLE)
>
> Because all you need to do is strip off the parameter information

This is just FYI ...

The TPM feature that adds parameter or handle numbers to the return code 
is optional.  So, masking them out is OK, but don't do anything that 
requires that 3 bit field to be accurate.






------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
