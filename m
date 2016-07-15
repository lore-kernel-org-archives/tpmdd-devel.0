From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: fix byte-order for the value
 read by tpm2_get_tpm_pt
Date: Thu, 14 Jul 2016 20:17:01 -0700
Message-ID: <20160715031701.GA25406@apronin>
References: <1468544838-9990-1-git-send-email-apronin@chromium.org>
	<1468544838-9990-3-git-send-email-apronin@chromium.org>
	<20160715031046.GC9347@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160715031046.GC9347-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 09:10:46PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2016 at 06:07:18PM -0700, Andrey Pronin wrote:
> > Change-Id: I7d71cd379b1a3b7659d20a1b6008216762596590
> > Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >  drivers/char/tpm/tpm2-cmd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > index a1673dc..a88b31e 100644
> > +++ b/drivers/char/tpm/tpm2-cmd.c
> > @@ -703,7 +703,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
> >  
> >  	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), desc);
> >  	if (!rc)
> > -		*value = cmd.params.get_tpm_pt_out.value;
> > +		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
> 
> Huh.
> 
> Jarkko: Are you running sparse on the tpm stuff? The annotations look
> right here, sparse should have complained on this? Andrey, did sparse
> complain here or is there something more serious wrong as well??
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> Jason

No, this is not sparse complaining. I tried using tpm2_get_tpm_pt() to
read permanent flags and discovered that it was missing byte-ordering
conversion. The only place tpm2_get_tpm_pt() was used before was in
tpm2_gen_interrupt, which discarded the result. So, nobody noticed,
I guess.

Andrey

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
