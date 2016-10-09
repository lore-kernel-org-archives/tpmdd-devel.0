From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 6/8] tpm: remove printk error messages
Date: Sun, 9 Oct 2016 17:22:08 -0600
Message-ID: <20161009232208.GB24139@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-7-git-send-email-nayna@linux.vnet.ibm.com>
	<57F9A392.7050302@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57F9A392.7050302-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Oct 09, 2016 at 07:25:30AM +0530, Nayna wrote:

> >diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> >index 22b8f81..1464cae 100644
> >+++ b/drivers/char/tpm/tpm_of.c
> >@@ -31,40 +31,34 @@ int read_log_of(struct tpm_chip *chip)
> >  	log = &chip->log;
> >  	if (chip->dev.parent->of_node)
> >  		np = chip->dev.parent->of_node;
> >-	if (!np) {
> >-		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
> >+	if (!np)
> >  		return -ENODEV;
> >-	}


> >  	sizep = of_get_property(np, "linux,sml-size", NULL);
> >  	if (sizep == NULL) {
> >-		pr_err("%s: ERROR - SML size not found\n", __func__);
> >-		goto cleanup_eio;
> >+		dev_dbg(&chip->dev, "%s: ERROR - SML size not found\n",
> >+			__func__);
> >+		return -EIO;
> >  	}

The properties are optional (eg my DT bound TPMs on ARM do not have
them) so I'm not sure the debug is appropriate either...

Everything else looks OK to me.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
