From: "Wilck, Martin" <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Fri, 18 Dec 2015 12:21:01 +0100
Message-ID: <C5A28EF7B98F574C85C70238C8E9ECC04E6940754E@ABGEX74E.FSC.NET>
References: <1450021353-8775-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF194@ABGEX74E.FSC.NET>
	<20151214095830.GA21291@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF197@ABGEX74E.FSC.NET>
	<20151214112501.GA26100@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E682BF19D@ABGEX74E.FSC.NET>
	<20151215233237.GA31965@obsidianresearch.com>
	<201512161652.tBGGqWPG019442@d03av04.boulder.ibm.com>
	<20151216171633.GB32594@obsidianresearch.com>
	<201512161721.tBGHLqXh009986@d03av03.boulder.ibm.com>
	<20151216174523.GC32594@obsidianresearch.com>
	<201512161804.tBGI47vu000331@d01av02.pok.ibm.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E69407545@ABGEX74E.FSC.NET>
	<201512171533.tBHFXn35003792@d03av02.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201512171533.tBHFXn35003792-nNA/7dmquNI+UXBhvPuGgqsjOiXwFzmk@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Do, 2015-12-17 at 10:23 -0500, Stefan Berger wrote:

> > kernel space. Can you point out a particular part of the problem
> that
> > could be solved better or more easily in user space?
> 
> User space would handle any number of client applications. It would
> handle
> the arbitration between applications from concurrent TPM usage while
> one
> application needs to access the TPM for a sequence of commands that
> requires
> access to session and key slots. This application can use the TPM
> directly
> with commands it passes through /dev/tpm0, so there's no need for a
> higher
> level API (provided by the TPM driver) for the usage of the TPM or the
> need
> to intercept commands where one application's usage of the TPM would
> interfere with another application's usage of TPM, such as one
> application
> swapping out the context of another applications keys/session and/or
> deleting
> another applications session and key handles.

I had asked for things that user space could do *better* than the
kernel. Could you point that out more clearly?

> And, as mentioned by Andreas, the kernel becomes attackable if it
> needs to
> handle hundred's of applications' sessions and contexts that may these
> applications may create for the purpose of exhausting resources.

It seems to be controversial whether that represents a real threat.
Similar threats exist in many places where the kernel has to user space
cache data for slow devices. Techniques are available to deal with it.

> > I am not voting for "replacing TSS" as Jason suggested in a previous
> > email. I expect that the industry will standardize on the TSS API,
> so
> > Linux will have to provide it to the upper layers. If resource
> 
> And it can do so via a user space library, no ?

Yes, certainly. All this talk is only about the TAB/RM.

> > Rogue user space applications could even
> > use the "keyctl" mechanism to bypass the tcsd and obtain priority
> access
> > to the TPM resources.
> 
> The only way to restrict this would be to only allow root access to
> the keyctl commands affecting the TPM.

I'll leave it to Jarkko to comment on that. 
Btw, wouldn't the "keys, trusted" API need some sort of resource
management, too? And wouldn't it make sense to merge that all into a
single TPM resource pool?

> > management was done in the kernel, a trivial user space "tcsd" could
> > simply sit on top of the kernel interface. That would provide a
> reliable
> > resource-managed TSS interface to application, what else would they
> > need?
> 
> A daemon that implements this functionality and would be the only
> application usng /dev/tpm0 could do the same.

Not quite, because this daemon wouldn't be fully in control of the
resources it manages.

Regards
Martin

> 
>    Stefan
> 
> > 
> > Regards
> > Martin
> > 
> > > 
> > >    Stefan
> > > > 
> > > > Jason
> > > > 
> > > 
> 
------------------------------------------------------------------------------
