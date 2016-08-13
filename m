From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 2/3] TPM2.0: TPM Device Tree
 Documentation
Date: Fri, 12 Aug 2016 20:42:30 -0600
Message-ID: <20160813024230.GA26929@obsidianresearch.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20160809221239.GB5535@obsidianresearch.com>
	<57ADC2B5.3040903@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57ADC2B5.3040903-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 12, 2016 at 06:06:05PM +0530, Nayna wrote:
> >  Documentation/devicetree/bindings/submitting-patches.txt
> >
> >And be sure to follow all the requirements, including CC'ing the
> >right maintainers

> Sure, will do. Can you tell me who all should I copy ?

That information is in the file

> >>Changelog v2:
> >>         * Added documentation in v2.
> >
> >Do not include these lines in commit messages, put them after the
> >diff stat.
> 
> Actually I have not added Changelog during commit, I have put them in patch
> before posting. However, will add them after diff next time.

No diff, after the diffstat, before the deiff.

> >>+	phandle = <0x10000017>;
> >>+	linux,phandle = <0x10000017>;
> >
> >  What are these?
> 
> Sorry I didn't get your question here. I have written in the format as
> suggested for device-tree documentation and looking at other device-nodes
> documentation. And so this is an example entry as I saw in other docs.

I mean the two phandle things

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
