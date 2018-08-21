From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 02/23] TPM: Provide a facility for a
 userspace TPM emulator
Date: Tue, 21 Aug 2018 12:31:40 -0600
Message-ID: <20180821183140.GD25543@ziepe.ca>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
 <153486702302.13066.15889029286852815542.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <153486702302.13066.15889029286852815542.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 21, 2018 at 04:57:03PM +0100, David Howells wrote:
> Provide a misc device file (/dev/tpm_emul) by which a userspace TPM emulator
> can set up a virtual TPM device under the control of the TPM frontend.  The
> way this works is:
> 
>  (1) The emulator opens /dev/tpm_emul which is provided by the tpm_user
>      driver.
> 
>  (2) tpm_user registers a TPM device and the tpm driver creates a /dev/tpmN
>      misc device for the trousers package and suchlike to access.
> 
>  (3) The emulator sits in read() on the emulator device waiting for a command
>      to come through.
> 
>  (4) tpm_user passes requests from /dev/tpmN to the emulator's read() call.
> 
>  (5) The emulator processes the request.
> 
>  (6) The emulator either write()'s the reply or calls ioctl(fd,0,0) to cancel
>      the command.
> 
>  (7) The emulator goes back to read() to wait for the next command.
> 
>  (8) tpm_user passes the reply back to the tpm driver which passes it back to
>      /dev/tpmN.
> 
> When the emulator closes /dev/tpm_emul, the TPM driver is unregistered and the
> /dev/tpmN misc device is then removed.  Any outstanding requests are aborted
> and -EIO will be returned from then on.  Multiple TPMs can be registered.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  drivers/char/tpm/Kconfig         |   13 +
>  drivers/char/tpm/Makefile        |    1 
>  drivers/char/tpm/tpm_user_emul.c |  672 ++++++++++++++++++++++++++++++++++++++
>  include/linux/wait.h             |   11 +
>  4 files changed, 697 insertions(+)
>  create mode 100644 drivers/char/tpm/tpm_user_emul.c

This looks to duplicate the vtpm stuff...

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
