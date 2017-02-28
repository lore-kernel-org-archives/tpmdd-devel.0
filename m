From: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 6/7] tpm: expose spaces via a device
	link /dev/tpms<n>
Date: Tue, 28 Feb 2017 12:22:36 -0500
Message-ID: <c8e90ebc-a0f5-4861-933b-7b4978eda684@linux.vnet.ibm.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
	<20170216192529.25467-7-jarkko.sakkinen@linux.intel.com>
	<20170223090917.jq7thil5ggjmagil@intel.com>
	<1487941328.2249.23.camel@HansenPartnership.com>
	<20170226114440.5ksg3lx27ylekvbx@intel.com>
	<20170226183040.GA4272@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170226183040.GA4272-DHO+NtfOqB5PEDpkEIzg7wC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Dr. Greg Wettstein" <greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 2/26/2017 1:30 PM, Dr. Greg Wettstein wrote:
>
> For example, Ken's tools which come in his TSS2 library, don't work
> properly with the 'spaces' device due to the virtualization lifetime.
> As an example, the getcapability call will 'lie' about the number of
> transient handles which are available through the device.  Attempts to
> string multiple transaction sequences together will fail as well.

Two comments:

1 = The intent of the command line tools was for rapid prototyping 
scripts against a SW TPM, and then as sample code for writing the 
application.

2 - If you really want to script against a hardware TPM, it can be done. 
  Simply place a proxy between the TSS and the TPM device driver.  The 
proxy passes commands from the TCP socket to the TPM device driver.  It 
keeps the connection open so the resource manager doesn't flush between 
transactions.

The proxy can be obtained from here.  It's from TPM 1.2 days, but it 
works for TPM 2.0 as well.

https://sourceforge.net/projects/ibmswtpm/files/?source=navbar


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
