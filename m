From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] add irq validity check in
	tpm_i2c_nuvoton driver
Date: Tue, 12 Jul 2016 11:33:26 -0600
Message-ID: <20160712173326.GA9286@obsidianresearch.com>
References: <1467194329-5543-1-git-send-email-andrew.zamansky@nuvoton.com>
	<1467194329-5543-3-git-send-email-andrew.zamansky@nuvoton.com>
	<20160629140339.GA4589@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160629140339.GA4589-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jun 29, 2016 at 05:03:39PM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 29, 2016 at 12:58:49PM +0300, andrew zamansky wrote:
> > if irq==0 (actualy invalid value) then error is printed to dmesg after
> > trying to register to 0 interrupt 
> > 
> >  drivers/char/tpm/tpm_i2c_nuvoton.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > index 75a80e466..3081529 100644
> > +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > @@ -554,7 +554,9 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
> >  	 *   TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT
> >  	 * The IRQ should be set in the i2c_board_info (which is done
> >  	 * automatically in of_i2c_register_devices, for device tree users */
> > -	chip->flags |= TPM_CHIP_FLAG_IRQ;
> > +	if(chip->flags)
> > +		chip->flags |= TPM_CHIP_FLAG_IRQ;
> > +
> >  	priv->irq = client->irq;
> >  
> >  	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> PS. There's a style error. "if()" should be "if ()". I don't mind fixing
> that. Just remember that next time.

Andrew/Jarkko:

Uhm, this looks wrong to me.. The original code was like this:

-       chip->vendor.irq = client->irq;
-       if (chip->vendor.irq) {

And was wrongly changed to this:

+       chip->flags |= TPM_CHIP_FLAG_IRQ;
+       priv->irq = client->irq;
+       if (chip->flags & TPM_CHIP_FLAG_IRQ) {

Jarkko, can you fold this into the patch to fix it please:

diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index e63ea1652d8d..826698234336 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -559,12 +559,8 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	 *   TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT
 	 * The IRQ should be set in the i2c_board_info (which is done
 	 * automatically in of_i2c_register_devices, for device tree users */
-	if(chip->flags)
-		chip->flags |= TPM_CHIP_FLAG_IRQ;
-
 	priv->irq = client->irq;
-
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
+	if (client->irq) {
 		dev_dbg(dev, "%s() priv->irq\n", __func__);
 		rc = devm_request_irq(dev, client->irq,
 				      i2c_nuvoton_int_handler,
@@ -574,9 +570,9 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 		if (rc) {
 			dev_err(dev, "%s() Unable to request irq: %d for use\n",
 				__func__, priv->irq);
-			chip->flags &= ~TPM_CHIP_FLAG_IRQ;
 			priv->irq = 0;
 		} else {
+			chip->flags |= TPM_CHIP_FLAG_IRQ;
 			/* Clear any pending interrupt */
 			i2c_nuvoton_ready(chip);
 			/* - wait for TPM_STS==0xA0 (stsValid, commandReady) */

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
