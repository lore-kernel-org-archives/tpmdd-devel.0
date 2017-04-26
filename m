From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: What does error code 38 mean? -> hex vs. decimal
Date: Wed, 26 Apr 2017 12:18:08 -0700
Message-ID: <20170426191808.kkvbg4iynbwysu6k@rhwork>
References: <trinity-decde0f7-fedc-4dc2-b8e0-87a910625951-1492997557494@msvc-mesg-gmx108>
	<odqn2s$72s$1@blaine.gmane.org>
Reply-To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <odqn2s$72s$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed Apr 26 17, Ken Goldman wrote:
>On 4/23/2017 9:32 PM, Peter Huewe wrote:
>> 38=0x26= invalid post init, which means tpm did not receive tpm_startup
>> command after reset.
>
>A minor observation:
>
>While the TPM 1.2 specification listed error codes in decimal, TPM 2.0
>uses hex, and further has a lot of bit level encoding.
>
>Thus, for TPM 2.0, it would be easier if error messages printed TPM
>errors in hex.
>
>
>
>------------------------------------------------------------------------------
>Check out the vibrant tech community on one of the world's most
>engaging tech sites, Slashdot.org! http://sdm.link/slashdot
>_______________________________________________
>tpmdd-devel mailing list
>tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

Maybe the following?

--8<--

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index bd2128e0b56c..e6e60f9f428c 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -453,9 +453,14 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
                return -EFAULT;
 
        err = be32_to_cpu(header->return_code);
-       if (err != 0 && desc)
-               dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
-                       desc);
+       if (err != 0 && desc) {
+               if (chip->flags & TPM_CHIP_FLAG_TPM2)
+                       dev_err(&chip->dev, "A TPM error (0x%x) occurred %s\n", err,
+                               desc);
+               else
+                       dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
+                               desc);
+       }
        if (err)
                return err;

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
