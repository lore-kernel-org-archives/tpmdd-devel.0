From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] Autodetect TCG event log version
Date: Wed, 5 Apr 2017 13:44:24 -0700
Message-ID: <58E55728.7010508@vmware.com>
References: <20170329074328.y5rmk5wh3rj5kgcg@petr-dev3.eng.vmware.com>
	<20170405114053.pihivxfnotxhsv36@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170405114053.pihivxfnotxhsv36-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

Jarkko Sakkinen wrote:
> On Wed, Mar 29, 2017 at 12:43:28AM -0700, Petr Vandrovec wrote:
>> From: Petr Vandrovec<petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>>
>> Code expects that TPM1 devices use TPM1 version of the log,
>> and TPM2 devices use TPM2 version of the log.  While that
>> is strongly recommended by the spec, and now required by
>> Microsoft certification, there are systems that use TPM2
>> chip with SHA-1 only log.
>
> Do you have example of such system? I don't know any.

My Dell Inspiron laptop after I upgraded firmware on TPM from TPM1.2 to 
TPM2.0.  I can select that I want to use SHA-256 in the firmware's 
setup, but when I do so TPM PCR registers are updated with both SHA-1 
and SHA-256, while TCG log is TPM1 format, with SHA-1 hashes only.

>> So let's do detection based on first event in the log -
>> if it is Spec ID Event03, log is crypto-agile log. otherwise
>> it is SHA-1 log, or malformed bunch of bytes.
>
> "Spec ID Event03" is not even english. Why are using it as it was
> part of an english sentence? I'm not a native speaker either but
> you should at least try to write understandable language.

"Spec ID Event03" is name of the TPM2 log format.  See for example Table 
15 in 
https://trustedcomputinggroup.org/wp-content/uploads/PC-ClientPlatform_Profile_for_TPM_2p0_Systems_v49_161114_public-review.pdf. 
  I use "Spec ID Event03" to make it clear that I'm talking about 
current version of crypto-agile TPM2 log format, not about earlier versions.

> 1. What specification are you talking about?

PC Client Platform Profile for TPM 2.0 systems.  It is also referenced 
from TPM2's EFI Protocol specification 
(https://trustedcomputinggroup.org/wp-content/uploads/EFI-Protocol-Specification-rev13-160330final.pdf) 
Table 3.

> 2. What structure in that specification has this data and what
>     is the purpose of that structure?

It describes format of the log.  If first event in the log is not "Spec 
ID Event03" (see chapter 9.4.5.1 in PC Client platform profile mentioned 
above), then log is not TPM2 log described by current TPM spec, and 
should not be parsed as such (it may be "Spec ID Event02" format, or it 
may be TPM1 log format, as is the case with my Dell box).

> 3. Which field in that structure contains this string value.

Signature.  You can see 
https://drive.google.com/open?id=0B7WL11GSMhrQQ1RCMmRmM2paR3c for TPM2 
log formatted according to the PC Client Platform Profile spec.

							Petr

>
> /Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
