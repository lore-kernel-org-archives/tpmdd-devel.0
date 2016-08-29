From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] TPM2.0:Adds securityfs support for
 TPM2.0 eventlog
Date: Mon, 29 Aug 2016 11:16:39 -0600
Message-ID: <20160829171639.GA18728@obsidianresearch.com>
References: <1469774679-25232-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1469774679-25232-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20160729171428.GB6331@obsidianresearch.com>
	<nq1b79$kkn$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <nq1b79$kkn$1@blaine.gmane.org>
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

On Mon, Aug 29, 2016 at 08:52:59AM -0400, Ken Goldman wrote:
> On 7/29/2016 1:14 PM, Jason Gunthorpe wrote:
> >
> > The bios log is defined to be host endian?
> >
> > Please reference the standard in a comment that these structs are
> > coming from.
> 
> The BIOS log is little endian.  That is, all multi-byte values are 
> little endian.  Examples are the pcrIndex, eventType, and eventSize,
> as well as the digest count and hashAlg.
> 
>  From the "TCG PC Client Platform Firmware Profile Specification"
> 
> 1.7	Specification Conventions
> 
> 1.	All constants and data SHALL be represented as Little Endian format 
> unless otherwise explicitly stated.

Surely all those structs need to be tagged le32/etc then?

Jason

------------------------------------------------------------------------------
