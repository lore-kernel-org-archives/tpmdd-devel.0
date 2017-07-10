From: Josh Zimmerman via tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: [PATCH v7 0/2] Run TPM2_Shutdown on system
 shutdown
Date: Mon, 10 Jul 2017 12:14:31 -0700
Message-ID: <CAHSjozDJgKOAyJiKsyF9dg=z1-2jkUXVq6V8azzoTcM8KbvvXA@mail.gmail.com>
References: <20170625215324.17467-1-joshz@google.com>
	<1498742891.30068.1.camel@linux.intel.com>
	<20170629195423.fmh5mxhwbh7aaexa@linux.intel.com>
Reply-To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170629195423.fmh5mxhwbh7aaexa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Excellent, thanks very much for the reviews and your time!
Josh


On Thu, Jun 29, 2017 at 12:54 PM, Jarkko Sakkinen
<jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Thu, Jun 29, 2017 at 04:28:11PM +0300, Jarkko Sakkinen wrote:
>> On Sun, 2017-06-25 at 14:53 -0700, Josh Zimmerman wrote:
>> > This patchset causes all devices in the tpm class to issue TPM2_Shutdown
>> > when the system is shutting down.
>> >
>> > As a prerequisite, it adds a "shutdown" method to "struct class".
>> >
>> > Since this bug can cause users to be locked out of their TPMs, I'd like
>> > this patch included in at least 4.4 and 4.9. 4.1 is nice-to-have but not
>> > essential.
>> >
>> > gregkh Acked the proposal for stable in v3 of this patch.
>> >
>> >  drivers/base/core.c          |  6 +++++-
>> >  drivers/char/tpm/tpm-chip.c  | 34 ++++++++++++++++++++++++++++++++++
>> >  drivers/char/tpm/tpm-sysfs.c |  3 +++
>> >  include/linux/device.h       |  2 ++
>> >  4 files changed, 44 insertions(+), 1 deletion(-
>>
>> Josh,
>>
>> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> /Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
