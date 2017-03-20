From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 2/7] tpm: validate TPM 2.0 commands
Date: Mon, 20 Mar 2017 11:23:05 -0600
Message-ID: <20170320172305.GA4990@obsidianresearch.com>
References: <20170303151912.14752-1-jarkko.sakkinen@linux.intel.com>
	<20170303151912.14752-3-jarkko.sakkinen@linux.intel.com>
	<22e8fa0caf8b4386a12cd93ee7170ed5@MUCSE603.infineon.com>
	<20170317161614.GA28082@obsidianresearch.com>
	<bca2bee3c1b84100ac72238425ac4791@MUCSE612.infineon.com>
	<12e63cdba1e34cac9b82e4bff9621ae6@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <12e63cdba1e34cac9b82e4bff9621ae6-nFblLGNE8XKJSz+rYg/bSJowlv4uC7bZ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 20, 2017 at 09:54:41AM +0000, Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
> >>> 2. When upgrading the firmware on my TPM, it switches to a
> >>> non-standard communication mode for the upgrade process and does not
> >>> communicate using TPM2.0 commands during this time. Rejecting
> >>> non-TPM2.0 commands means upgrading won't be possible anymore.
> >>
> >> How non standard? Is the basic header even there? Are the lengths and
> >> status code right?
> >>
> >> This might be an argument to add a 'raw' ioctl or something specifically
> >> for this special case.
> >
> > It follows the regular TPM command syntax and looks something like 1.2
> > commands.
> 
> Yep, so most of it already works with the current implementation.
> 
> There are a few special cases that need some thought though. For
> example, it is possible to use an upgrade to switch the TPM family
> from 1.2 to 2.0 (or vice versa). In this case it seems useful to let
> the kernel reinitialize the TPM driver, so it uses the correct
> timeouts for communication, activates the correct features (resource
> manager or not?), etc., without needing to reboot the system.

It would be nice to do this via plug/unplug with existing sysfs
machinery.

> Another problem arises when the upgrade process is interrupted,
> e.g. because power is lost. Then the TPM is stuck in its
> non-standard upgrade mode, so the kernel does not recognize it as a
> valid TPM device and does not export /dev/tpm<n>. But without the
> device node the upgrader is unable to restart the upgrade process,
> leaving the TPM forever inaccessible.

I guess you'd have to teach the TPM core about a new chip mode besides
1.2, 2.0 - some kind of 'upgrade' mode.

So the flow would be to send the upgrade command, unplug/replug the
driver to switch to 'upgrade' mode (which could happen if there was a
reboot?) do the upgrade, then unplug/replug to rediscover the 'new'
TPM.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
