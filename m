From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Sat, 2 Jan 2016 13:39:57 -0700
Message-ID: <20160102203957.GA19490@obsidianresearch.com>
References: <20151218105148.GA12882@intel.com>
	<20151218105323.GB12882@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
	<20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
	<20151222212348.GB9461@obsidianresearch.com>
	<n5ed19$pqo$1@ger.gmane.org> <20151224114241.GA5119@intel.com>
	<n5h1rj$nkb$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <n5h1rj$nkb$1@ger.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Dec 24, 2015 at 10:09:43AM -0500, Ken Goldman wrote:

> I can understand small "patches" to fix bugs, but not for new code.

You need to do it in smaller functional stages.

Ie the first step would be to create a new /dev/ node for the
'virtualized' tpm (vs the raw tpm we have now). We'd want to have some
idea exactly what that is and exactly what the UAPI looks like, and
make decsisions like, should there be one per tpm or one for all tpms?

Next step would be to parse commands and require that the commands are
'valid' and of the allowed subset.

Next step would be to parse commands deeper and do access control on
all the tpm objects. Ie a vtpm fd can only use key ids it created.

Next step would be auto-cleanup of created objects when the vtpm fd
closes, ie destroy key ids created on the fd

Next step would be hooking kernel access through the above

Next step would be allowing objects to be swapped in/out

Jason

------------------------------------------------------------------------------
