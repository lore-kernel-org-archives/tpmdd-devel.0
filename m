From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Tue, 22 Dec 2015 14:23:48 -0700
Message-ID: <20151222212348.GB9461@obsidianresearch.com>
References: <9F48E1A823B03B4790B7E6E69430724DA58648F1@EXCH2010A.sit.fraunhofer.de>
	<201512171620.tBHGK3GE030569@d03av04.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
	<20151218105148.GA12882@intel.com>
	<20151218105323.GB12882@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
	<20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724DA586A57C-wI35/lLZEdRyXeJKmmMAp2SU2VBt9E6NG9Ur7JDdleE@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Dec 21, 2015 at 01:22:04PM +0000, Fuchs, Andreas wrote:
> maintainers) if a 3-5 kLoC module would be generally acceptable for a 
> TPM-ResourceManager?

I'd be alarmed if it is that much. The TPM format is very amenable to
doing this, a well designed table driven approach should be quite
small on the rpc handling side. The key is to not overthink/overdesign
it too much.

I have an entire tpm1.2 userpace in less than 2kloc, so I struggle to
see why a simple resource manager would be so big.

1-2kloc is not a big deal kernel wise if it is well written and in the
kernel style.

Jason

------------------------------------------------------------------------------
