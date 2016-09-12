From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH 1/1] tpm/tpm-dev: fix broken style
	in	copy_from_user
Date: Mon, 12 Sep 2016 09:06:01 -0700
Message-ID: <3113B445-E63D-45C3-8B6A-DFDB1B5DDC7D@gmx.de>
References: <1473621730-23125-1-git-send-email-tomas.winkler@intel.com>
	<20160911203849.GA26511@intel.com>
	<E2960FB9-598A-4289-9486-9B8AFD054E95@gmx.de>
	<20160912075637.GB5094@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160912075637.GB5094-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



Am 12. September 2016 00:56:37 GMT-07:00, schrieb Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
>On Sun, Sep 11, 2016 at 09:39:04PM -0700, Peter Huewe wrote:
>> Jarkko,
>> what's the ack for?
>> As maintainer you usually apply and sign off or don't.
>> Ack is more if you are not touching the patch but still think it's
>good (e.g.goes through another tree.
>
>I've based my use of acked-by based on section 12 of
>
>https://www.kernel.org/doc/Documentation/SubmittingPatches
>
>Have I somehow misunderstood it? I add signed-off-by's before I send
>a pull requst even if the patch contains reviewd/acked-by by me.

Hi,
you usually add your signed-off while applying.
If you apply the patch you take an active role in forwarding the patch.

That's why this section applies:
"The Signed-off-by: tag indicates that the signer was involved in the development of the patch, or that he/she was in the patch's delivery path."
" If a person was not directly involved in the preparation or handling of a patch but wishes to signify and record their approval of it then they can ask to have an Acked-by: line added to the patch's changelog. "

E.g. Rob would do that for the dt bindings.
He does have a quick look at a binding and says "okay for him" by indicating the ACK.

So rule of thumb
If it goes through your tree or you are the author ->signed off
If not -> ack

Reviewed-by is a bit unrelated, and content wise stronger as ack, but weaker approval wise.


Peter


>
>/Jarkko
>
>> @Thomas:thanks for your contribution, but please spellcheck your
>descriptions, please.
>> 
>> Am 11. September 2016 13:38:49 GMT-07:00, schrieb Jarkko Sakkinen
><jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
>> >On Sun, Sep 11, 2016 at 10:22:10PM +0300, Tomas Winkler wrote:
>> >> Straighten unneeded line brake and drop useless cast to void.
>> >> 
>> >> Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> >
>> >Thanks.
>> >
>> >Acked-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> >
>> >/Jarkko
>> >
>> >> ---
>> >>  drivers/char/tpm/tpm-dev.c | 3 +--
>> >>  1 file changed, 1 insertion(+), 2 deletions(-)
>> >> 
>> >> diff --git a/drivers/char/tpm/tpm-dev.c
>b/drivers/char/tpm/tpm-dev.c
>> >> index 912ad30be585..9782df406345 100644
>> >> --- a/drivers/char/tpm/tpm-dev.c
>> >> +++ b/drivers/char/tpm/tpm-dev.c
>> >> @@ -130,8 +130,7 @@ static ssize_t tpm_write(struct file *file,
>const
>> >char __user *buf,
>> >>  
>> >>  	mutex_lock(&priv->buffer_mutex);
>> >>  
>> >> -	if (copy_from_user
>> >> -	    (priv->data_buffer, (void __user *) buf, in_size)) {
>> >> +	if (copy_from_user(priv->data_buffer, buf, in_size)) {
>> >>  		mutex_unlock(&priv->buffer_mutex);
>> >>  		return -EFAULT;
>> >>  	}
>> >> -- 
>> >> 2.7.4
>> >> 
>> >
>>
>>------------------------------------------------------------------------------
>> >_______________________________________________
>> >tpmdd-devel mailing list
>> >tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>> >https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>> 
>> -- 
>> Sent from my mobile

-- 
Sent from my mobile

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
