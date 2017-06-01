From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 2/2] Add "shutdown" to "struct class".
Date: Thu, 1 Jun 2017 09:55:20 -0700
Message-ID: <CAHSjozBfU0Lmp_SnA5GcmACWxG4E1NdEcb9v7gcs5CLREuRNUA@mail.gmail.com>
References: <CAHSjozA+xfUM-NmbP7Kb5B=T+u6qaEFzMWeF6OxX2N7-xHLAVQ@mail.gmail.com>
	<20170601163905.GA2694@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170601163905.GA2694-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 1, 2017 at 9:39 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Jun 01, 2017 at 09:33:43AM -0700, Josh Zimmerman wrote:
>
>> -               if (dev->bus && dev->bus->shutdown) {
>> +               if (dev->class && dev->class->shutdown) {
>> +                       if (initcall_debug)
>> +                               dev_info(dev, "shutdown\n");
>> +                       dev->class->shutdown(dev);
>> +               } else if (dev->bus && dev->bus->shutdown) {
>>                         if (initcall_debug)
>>                                 dev_info(dev, "shutdown\n");
>>                         dev->bus->shutdown(dev);
>
> Looking at this closer, now you definately have to change the TPM
> patch to call through to the other shutdown methods. We can say
> current TPM drivers have no driver->shutdown, but we cannot be sure
> about the bus->shutdown, so may as well call both from tpm's
> class->shutdown.
Why can't we be sure? Could bus->shutdown methods be registered
outside of the drivers/char/tpm/ tree?

> I would say this should be done after the tpm2_shutdown completes as
> lower level shutdowns could remove register access.

This doesn't necessarily work.  The spec states that tpm2_shutdown
must be the last command issued for an orderly shutdown, so if we call
the lower-level functions after the tpm2_shutdown, the shutdown may
not be orderly. It is also a problem that register access could be
removed, though. I'm not sure what the best way to deal with this is
(I lack sufficient familiarity with the codebase). Do you have
thoughts on how to resolve this conflict?

Josh

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
