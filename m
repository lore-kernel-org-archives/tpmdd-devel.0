From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Intel NUC and fTPM issue on 4.9.2
Date: Thu, 16 Feb 2017 12:03:29 -0700
Message-ID: <20170216190329.GC7257@obsidianresearch.com>
References: <CAH=yMtLydrTfn3_RkzZFpRL-sASUsHPdxX9m-HJUTyjv=D3ksg@mail.gmail.com>
	<20170216180116.GA7145@obsidianresearch.com>
	<CAH=yMtJkmxxm6sn=1DmakXW+P=E7rsBd3iwqsSwaVBvxazE29w@mail.gmail.com>
	<20170216181905.GA7257@obsidianresearch.com>
	<CAH=yMt+tWWDMban86H53Or+KngYLUw5hN0aB=+DaJ+MQOK4=4g@mail.gmail.com>
	<CAH=yMtJ7qWq=YpRaUPh2zzOECjFGiwV3jfBc+4HuvW3wOYt_Vg@mail.gmail.com>
	<CAH=yMtLLrsyqLr9tOm+D2qvcCDNRO3P36hp8hCdJFVtDyJPWGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH=yMtLLrsyqLr9tOm+D2qvcCDNRO3P36hp8hCdJFVtDyJPWGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Davide Guerri <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 16, 2017 at 06:40:02PM +0000, Davide Guerri wrote:
>    Sorry I missed 1 line:
> 
>    [20417.678952] ACPI resource is [mem 0xfed40000-0xfed4087f flags 0x200]

The BIOS is broken.. That range declared in the ACPI is too small

Or the cmd_size is too big:

>    [20417.678990] map request is is [mem 0xfed40080-0xfed40fff flags 0x200]

I have no idea which.

If we trust the ACPI table then the cmd_size is 2047 bytes

If we trust the register then it is 3967..

Try this?

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index a7c870af916c3d..2d16cc4aa0f43b 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -233,6 +233,8 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
 		.flags	= IORESOURCE_MEM,
 	};
 
+	printk("map request is is %pr\n",&new_res);
+
 	/* Detect a 64 bit address on a 32 bit system */
 	if (start != new_res.start)
 		return (void __iomem *) ERR_PTR(-EINVAL);
@@ -243,6 +245,26 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
 	return priv->iobase + (new_res.start - io_res->start);
 }
 
+/*
+ * Work around broken BIOSs that return inconsistent values from the ACPI
+ * region vs the registers. Trust the ACPI region.
+ */
+static u64 crb_clamp_cmd_size(struct device *dev, struct resource *io_res,
+			      u64 start, u64 size)
+{
+	if (io_res->start > start || io_res->end < start)
+		return size;
+
+	if (start + size - 1 <= io_res->end)
+		return size;
+
+	dev_err(dev,
+		FW_BUG "ACPI region does not cover the entire command/response buffer. %pr vs %llx %llx\n",
+		io_res, start, size);
+
+	return io_res->end - start + 1;
+}
+
 static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 		      struct acpi_table_tpm2 *buf)
 {
@@ -267,6 +289,8 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 		return -EINVAL;
 	}
 
+	printk("ACPI resource is %pr\n",&io_res);
+
 	priv->iobase = devm_ioremap_resource(dev, &io_res);
 	if (IS_ERR(priv->iobase))
 		return PTR_ERR(priv->iobase);
@@ -278,14 +302,16 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 
 	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
 		  (u64) ioread32(&priv->cca->cmd_pa_low);
-	cmd_size = ioread32(&priv->cca->cmd_size);
+	cmd_size = crb_clamp_cmd_size(dev, &io_res, cmd_pa,
+				      ioread32(&priv->cca->cmd_size));
 	priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa, cmd_size);
 	if (IS_ERR(priv->cmd))
 		return PTR_ERR(priv->cmd);
 
 	memcpy_fromio(&rsp_pa, &priv->cca->rsp_pa, 8);
 	rsp_pa = le64_to_cpu(rsp_pa);
-	rsp_size = ioread32(&priv->cca->rsp_size);
+	rsp_size = crb_clamp_cmd_size(dev, &io_res, rsp_pa,
+				      ioread32(&priv->cca->rsp_size));
 
 	if (cmd_pa != rsp_pa) {
 		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
