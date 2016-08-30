From: "Peter Huewe" <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] Documentation: tpm: Adds the TPM device
 tree node documentation
Date: Tue, 30 Aug 2016 08:46:32 +0200
Message-ID: <trinity-7d511ee9-e33e-4cc0-88d7-abd58297fe7c-1472539592268@3capp-gmx-bs40>
References: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830063631.GA5336@intel.com>,
	<D8028209-446C-4C50-9AEC-25F6F8C98995@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <D8028209-446C-4C50-9AEC-25F6F8C98995-Mmb7MZpHnFY@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

I agree - I always get stuck upon the sml thing.
>
>Also, enabled should be "enabled", not "okay".

No!
okay/ok is a dt keyword! (Or at least used in everything else)

It has nothing to do whether the TPM is enabled/disabled/activated whatever
See http://www.devicetree.org/specifications-pdf table 2.4

Value Description
"okay" Indicates the device is operational
"disabled" Indicates that the device is not presently operational, but it might become operational in the
future (for example, something is not plugged in, or switched off).
Refer to the device binding for details on what disabled means for a given device.
"fail" Indicates that the device is not operational. A serious error was detected in the device, and it
is unlikely to become operational without repair.
"fail-sss" Indicates that the device is not operational. A serious error was detected in the device and it
is unlikely to become operational without repair. The sss portion of the value is specific to
the device and indicates the error condition detected.

------------------------------------------------------------------------------
