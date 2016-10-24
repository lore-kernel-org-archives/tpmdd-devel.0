From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] tpm_tis: Check return values from
	get_burstcount.
Date: Mon, 24 Oct 2016 10:43:09 -0700
Message-ID: <CAHSjozBWANwwaMD7ddqpdNSALFr2E0F2hxHZnxa4ShTsHRMVxA@mail.gmail.com>
References: <20161024155439.GA27123@google.com>
	<20161024173207.GA11533@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161024173207.GA11533-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 24, 2016 at 10:32 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Oct 24, 2016 at 08:54:39AM -0700, Josh Zimmerman wrote:
>> If the TPM we're connecting to uses a static burst count, it will report
>> a burst count of zero throughout the response read. However, get_burstcount
>> assumes that a response of zero indicates that the TPM is not ready to
>> receive more data. In this case, it returns a negative error code, which
>> is passed on to tpm_tis_{write,read}_bytes as a u16, causing
>> them to read/write far too many bytes.
>>
>> This patch checks for negative return codes and bails out from recv_data
>> and tpm_tis_send_data.
>>
>> Fixes: 1107d065fdf1
>
> huh?
>
> No signed off?
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
>
> </formletter>

Oh, I apologize. I was unfamiliar with the stable@ list, and was asked
in v1 of my patch to add it to CCs. I was unaware that there were
further prerequisites to doing so.  From reading
stable_kernel_rules.txt's requirements, it doesn't seem like this is
yet ready to be sent here, and perhaps it doesn't belong on the
stable@ list at all. Moving stable@ to BCC.

Josh

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
