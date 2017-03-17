From: <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 2/7] tpm: validate TPM 2.0 commands
Date: Fri, 17 Mar 2017 15:40:15 +0000
Message-ID: <22e8fa0caf8b4386a12cd93ee7170ed5@MUCSE603.infineon.com>
References: <20170303151912.14752-1-jarkko.sakkinen@linux.intel.com>
	<20170303151912.14752-3-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170303151912.14752-3-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> Check for every TPM 2.0 command that the command code is supported and
> the command buffer has at least the length that can contain the header
> and the handle area.

This breaks several use cases for me:

1. I've got a TPM that implements vendor-specific command codes. Those cannot be send to the TPM anymore, but are rejected with EINVAL.

2. When upgrading the firmware on my TPM, it switches to a non-standard communication mode for the upgrade process and does not communicate using TPM2.0 commands during this time. Rejecting non-TPM2.0 commands means upgrading won't be possible anymore.

3. I'd like to use the kernel driver to test my TPM implementation. So for example, I send an invalid command code to the TPM and expect TPM_RC_COMMAND_CODE in response, but now I get EINVAL instead and the TPM never sees the command.

>From my point of view, the kernel driver should provide a transparent communication channel to the TPM. Whatever I write to /dev/tpm<n> should arrive at the TPM device, so that the TPM can handle it and return the appropriate response. Otherwise, you'll end up reimplementing all the command handling logic, that is already part of the TPM's job, and as soon as you miss one case and behave differently than the TPM, something relying on this behavior will break.

I see two possible solutions:

1. When the driver does not know a command code, it passes through the command unmodified. This bears the risk of unknown side effects though, so TPM spaces might not be as independent as they should be.

2. Since the command code lookup is only really necessary for TPM spaces, it only gets activated when space != NULL. So the change will not affect /dev/tpm<n>, but only the new /dev/tpmrm<n>. As /dev/tpmrm<n> is not meant to be a transparent interface anyway, rejecting unknown commands is acceptable.

Alexander
------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
