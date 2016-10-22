From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] Check for error return values from
	get_burstcount.
Date: Sat, 22 Oct 2016 15:04:52 +0300
Message-ID: <20161022120452.uwh3utbjvezisbed@intel.com>
References: <20161021002129.GA9464@google.com>
	<20161021161334.e7hwhqj5ow5v47dg@intel.com>
	<CAHSjozCvzDWXFcW5TTqknFy8NEMh11xkJbx=CS_31jMU4AFhmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozCvzDWXFcW5TTqknFy8NEMh11xkJbx=CS_31jMU4AFhmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 21, 2016 at 04:01:13PM -0700, Josh Zimmerman wrote:
> On Fri, Oct 21, 2016 at 9:13 AM, Jarkko Sakkinen
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > On Thu, Oct 20, 2016 at 05:21:29PM -0700, Josh Zimmerman wrote:
> >> If the TPM we're connecting to uses a static burst count, it will report
> >> a burst count of zero throughout the response read. However, get_burstcount
> >> assumes that a response of zero indicates that the TPM is not ready to
> >> receive more data. In this case, it returns a negative error code, which
> >> is passed on to tpm_tis_{write,read}_bytes as a u16, causing
> >> them to read/write far too many bytes.
> >>
> >> This patch checks for negative return codes and bails out from recv_data
> >> and tpm_tis_send_data.
> >
> > I guess this would need a "Fixes:" tag, wouldn't it?
> Ah, yes. Good point.
> 
> >  I would also add
> >
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Will do when I mail the updated patch.
> 
> >> ---
> >>  drivers/char/tpm/tpm_tis_core.c | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> >> index e3bf31b..d0301dc 100644
> >> --- a/drivers/char/tpm/tpm_tis_core.c
> >> +++ b/drivers/char/tpm/tpm_tis_core.c
> >> @@ -186,6 +186,12 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
> >>                                chip->timeout_c,
> >>                                &priv->read_queue, true) == 0) {
> >>               burstcnt = min_t(int, get_burstcount(chip), count - size);
> >> +             if (burstcnt < 0) {
> >> +                     dev_err(&chip->dev,
> >> +                             "Unable to read burstcount in %s:%d (%s)\n",
> >> +                             __FILE__, __LINE__, __func__);
> >> +                     return rc;
> >> +             }
> >
> > "return burstcnt;"
> Done, thanks!
> 
> > I guess __func__ would be enough to deduce the call site?
> It is not; would you suggest removing it since it's redundant with
> __LINE__ and __FILE__? Or is there some other macro you know of that
> could be useful for determining the call site? (I had included it
> initially for the sake of ease of log reading, but that's perhaps not
> very compelling.)

It's an internal function to tpm_tis_core.c and there are exactly
two call sites for it. Just by printing __func__ you can determine
where it fails.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
