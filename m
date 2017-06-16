From: Josh Zimmerman via tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: [PATCH v5 2/2] Add "shutdown" to "struct class".
Date: Fri, 16 Jun 2017 11:31:27 -0700
Message-ID: <CAHSjozCNUtokE3fbvM=ezOzGoiDThm8z7kp_xAv3sdjjUetW4Q@mail.gmail.com>
References: <CAHSjozA+xfUM-NmbP7Kb5B=T+u6qaEFzMWeF6OxX2N7-xHLAVQ@mail.gmail.com>
	<20170616085747.c2wkkgsdjuyju6vm@intel.com>
	<20170616091452.txun2l3zni2zz7ne@intel.com>
Reply-To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170616091452.txun2l3zni2zz7ne-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

Just re-sent using git send-email; hopefully the must recent version will work.
Josh


On Fri, Jun 16, 2017 at 2:14 AM, Jarkko Sakkinen
<jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Fri, Jun 16, 2017 at 10:57:47AM +0200, Jarkko Sakkinen wrote:
>> On Thu, Jun 01, 2017 at 09:33:43AM -0700, Josh Zimmerman wrote:
>> > The TPM class has some common shutdown code that must be executed for
>> > all drivers. This adds some needed functionality for that.
>> >
>> > Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> > Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >
>> > -----
>> > v2: Add Signed-off-by.
>> > v3: Remove logically separate change.
>> > v4: Add "acked-by" and "cc".
>> > v5: Execute only one of the class/bus/driver's shutdown functions.
>>
>> This breaks the patch.
>>
>> > ---
>>
>> The changelog should be here.
>>
>> >  drivers/base/core.c    | 6 +++++-
>> >  include/linux/device.h | 2 ++
>> >  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> /Jarkko
>
>
> It actually doesn't probably break the patch because there are six
> dashes but is incorrectly positioned. You should but right before
> diffstat after three dashes. Git will ignore this part.
>
> Still getting this:
>
> $ git am -3 ~/Downloads/josh.patch
> Applying: Add "shutdown" to "struct class".
> error: patch fragment without header at line 36: @@ -407,6 +408,7 @@ struct class {
> error: could not build fake ancestor
> Patch failed at 0001 Add "shutdown" to "struct class".
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
>
> Look at the comment at the lie 1549:
>
> https://github.com/git/git/blob/master/apply.c
>
> I have no idea how you have exported and sent it but I would recommend
> to use standard git format-patch and git send-email commands to ensure
> the correct results.
>
> Please send the full patch set once you know it will cleanly apply.
>
> You could email it to yourself or some collegue and ask them to apply
> it as a test measure...
>
> /Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
